import psycopg2
from sqlalchemy import create_engine
import pandas as pd
import matplotlib.pyplot as plt
from faker import Faker
import random
import numpy as np
from scipy import stats

# -----------------------------
# 1. Параметры подключения
# -----------------------------
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'dbname': 'postgres',
    'user': 'postgres',
    'password': '7312'
}

# -----------------------------
# 2. SQLAlchemy-движок для pandas
# -----------------------------
DB_URL = (
    f"postgresql+psycopg2://{DB_CONFIG['user']}:{DB_CONFIG['password']}"
    f"@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['dbname']}"
)
engine = create_engine(DB_URL)

# -----------------------------
# 3. Соединение и очистка БД
# -----------------------------
conn = psycopg2.connect(**DB_CONFIG)
cursor = conn.cursor()
fake = Faker()

cursor.execute("""
TRUNCATE TABLE
    TracksArtists,
    TracksGenres,
    Ratings,
    Tracks,
    Releases,
    UsersArchive,
    Users,
    Artists,
    Genres
RESTART IDENTITY CASCADE;
""")
conn.commit()

# -----------------------------
# 4. Восстановление жанров
# -----------------------------
cursor.execute("SELECT COUNT(*) FROM Genres")
if cursor.fetchone()[0] == 0:
    base_genres = [
        'Rock','Alternative Rock','Pop','Hip-Hop','Jazz','Electronic',
        'Classical','Metal','Folk','Country','Blues','Reggae','Soul','R&B','Punk'
    ]
    cursor.executemany(
        "INSERT INTO Genres (GenreName, ParentGenre, Description) VALUES (%s, NULL, %s)",
        [(g, f"{g} genre") for g in base_genres]
    )
    conn.commit()

# -----------------------------
# 5. Генерация и вставка данных (увеличено в 10×)
# -----------------------------

# 5.1 Users: 1000 записей
users = []
for _ in range(1000):
    reg_date = fake.date_between(start_date='-5y', end_date='today')
    birth    = fake.date_of_birth(minimum_age=18, maximum_age=70)
    nickname = fake.user_name()
    gender   = random.choice(['Male','Female','Other'])
    status   = random.choice(['free','premium'])
    users.append((reg_date, nickname, birth, gender, status))

cursor.executemany(
    """
    INSERT INTO Users (RegistrationDate, Nickname, BirthDate, Gender, Status)
    VALUES (%s,%s,%s,%s,%s)
    """,
    users
)
conn.commit()

cursor.execute("SELECT UserId FROM Users")
user_ids = [row[0] for row in cursor.fetchall()]

# 5.2 Releases + Tracks: 500 релизов с единым жанром релиза
cursor.execute("SELECT GenreName FROM Genres")
genres = [row[0] for row in cursor.fetchall()]

release_ids = []
rel2genres = {}
for _ in range(500):
    title    = fake.sentence(nb_words=3).rstrip('.')
    rdate    = fake.date_between(start_date='-30y', end_date='today')
    rtype    = random.choice(['Album','Single','EP'])
    n_tracks = random.randint(1,8)

    # выберем один жанр для всего релиза
    main_genre = random.choice(genres)
    rel2genres_value = [main_genre]

    track_titles = [fake.sentence(nb_words=2).rstrip('.') for _ in range(n_tracks)]
    durations    = [fake.time(pattern="%H:%M:%S") for _ in range(n_tracks)]

    cursor.execute(
        """
        CALL AddReleaseWithTracks(
          %s::VARCHAR,
          %s::DATE,
          %s::VARCHAR,
          %s::TEXT[],
          %s::TIME[],
          NULL,
          NULL,
          NULL
        )
        """,
        (title, rdate, rtype, track_titles, durations)
    )
    conn.commit()

    cursor.execute("SELECT MAX(ReleaseId) FROM Releases")
    rid = cursor.fetchone()[0]
    release_ids.append(rid)
    rel2genres[rid] = rel2genres_value

# 5.3 TracksGenres: присвоим каждому треку жанр релиза
for rid, genre_list in rel2genres.items():
    genre = genre_list[0]
    cursor.execute("SELECT TrackId FROM Tracks WHERE ReleaseId = %s", (rid,))
    for (tid,) in cursor.fetchall():
        cursor.execute(
            "INSERT INTO TracksGenres (GenreName, TrackId) VALUES (%s,%s)",
            (genre, tid)
        )
conn.commit()

# 5.4 Ratings: 5000 записей с учётом жанрового смещения
genre_mu = {
    'Rock':7.5, 'Alternative Rock':7.0, 'Pop':6.0, 'Hip-Hop':6.5,
    'Jazz':8.0, 'Electronic':6.8, 'Classical':8.5, 'Metal':6.2,
    'Folk':7.2, 'Country':6.7, 'Blues':7.8, 'Reggae':7.0,
    'Soul':7.6, 'R&B':7.4, 'Punk':5.8
}

genre_sigma = {g:1.0 for g in genre_mu}

ratings = []
for _ in range(5000):
    uid = random.choice(user_ids)
    rid = random.choice(release_ids)
    gr  = rel2genres[rid][0]
    mu     = genre_mu.get(gr, 6.5)
    sigma  = genre_sigma.get(gr, 1.0)
    rate   = int(np.clip(round(np.random.normal(mu, sigma)), 1, 10))
    review = fake.sentence(nb_words=random.randint(5,20))
    ratings.append((rid, uid, rate, review))

cursor.executemany(
    """
    INSERT INTO Ratings (ReleaseId, UserId, RatingOutOf10, Review)
    VALUES (%s,%s,%s,%s)
    """,
    ratings
)
conn.commit()

# -----------------------------
# 6. Извлечение и агрегации
# -----------------------------

df_A = pd.read_sql(
    """
    SELECT tg.GenreName, AVG(r.RatingOutOf10) AS AvgRating
    FROM Ratings r
    JOIN Tracks t ON r.ReleaseId = t.ReleaseId
    JOIN TracksGenres tg ON t.TrackId = tg.TrackId
    GROUP BY tg.GenreName
    ORDER BY AvgRating DESC
    """, engine)

df_B = pd.read_sql(
    """
    SELECT EXTRACT(YEAR FROM ReleaseDate)::INT AS year, COUNT(*) AS cnt
    FROM Releases
    GROUP BY year
    ORDER BY year
    """, engine)

df_C = pd.read_sql(
    """
    SELECT r.UserId, COUNT(*) AS cnt
    FROM Ratings r
    GROUP BY r.UserId
    """, engine)

df_D = pd.read_sql(
    """
    WITH stats AS (
      SELECT t.ReleaseId,
             COUNT(*) AS track_count,
             AVG(r.RatingOutOf10) AS avg_rating
      FROM Tracks t
      LEFT JOIN Ratings r ON t.ReleaseId = r.ReleaseId
      GROUP BY t.ReleaseId
    )
    SELECT * FROM stats
    """, engine)

# -----------------------------
# 7. Визуализации (улучшенные)
# -----------------------------
plt.figure()
plt.hist(df_C['cnt'], bins=range(0, df_C['cnt'].max()+2))
plt.xticks(range(0, df_C['cnt'].max()+1))
plt.title('Распределение числа оценок на пользователя')
plt.xlabel('Число оценок')
plt.ylabel('Количество пользователей')
plt.show()

plt.figure()
plt.plot(df_B['year'], df_B['cnt'], marker='o')
plt.xticks(df_B['year'].unique(), rotation=45)
plt.title('Число релизов по годам')
plt.xlabel('Год')
plt.ylabel('Количество релизов')
plt.grid(True)
plt.tight_layout()
plt.show()

plt.figure(figsize=(12,6))
plt.bar(df_A['genrename'], df_A['avgrating'])
plt.xticks(rotation=45, ha='right')
plt.title('Средний рейтинг по жанрам')
plt.xlabel('Жанр')
plt.ylabel('Средний рейтинг')
plt.tight_layout()
plt.show()

# -----------------------------
# 8. Формулировка и проверка гипотез
# -----------------------------
print("Гипотезы:")
print("H1: Средний рейтинг жанра Rock отличается от среднего рейтинга жанра Pop.")
print("H2: Существует линейная корреляция между числом треков в релизе и его средним рейтингом.")
print("H3: Средние оценки пользователей со статусом 'premium' отличаются от средних оценок 'free'.")

# H1
rock_raw = pd.read_sql(
    """
    SELECT r.RatingOutOf10 AS rating
    FROM Ratings r
    JOIN Tracks t ON r.ReleaseId = t.ReleaseId
    JOIN TracksGenres tg ON t.TrackId = tg.TrackId
    WHERE tg.GenreName = 'Rock'
    """, engine)['rating'].values
pop_raw = pd.read_sql(
    """
    SELECT r.RatingOutOf10 AS rating
    FROM Ratings r
    JOIN Tracks t ON r.ReleaseId = t.ReleaseId
    JOIN TracksGenres tg ON t.TrackId = tg.TrackId
    WHERE tg.GenreName = 'Pop'
    """, engine)['rating'].values
if len(rock_raw)>=2 and len(pop_raw)>=2:
    t1, p1 = stats.ttest_ind(rock_raw, pop_raw, equal_var=False)
else:
    t1, p1 = np.nan, np.nan
    print("Недостаточно данных для H1")

# H2
x = df_D['track_count'].values
y = df_D['avg_rating'].fillna(0).values
if len(x)>=2 and len(y)>=2:
    r_coeff, p2 = stats.pearsonr(x, y)
else:
    r_coeff, p2 = np.nan, np.nan
    print("Недостаточно данных для H2")

# H3
_df_ratings = pd.read_sql(
    """
    SELECT r.RatingOutOf10 AS rating, u.Status AS status
    FROM Ratings r
    JOIN Users u ON r.UserId = u.UserId
    """, engine)
prem = _df_ratings[_df_ratings['status']=='premium']['rating'].values
free = _df_ratings[_df_ratings['status']=='free']['rating'].values
if len(prem)>=2 and len(free)>=2:
    t3, p3 = stats.ttest_ind(prem, free, equal_var=False)
else:
    t3, p3 = np.nan, np.nan
    print("Недостаточно данных для H3")

# -----------------------------
# 9. Вывод результатов тестов
# -----------------------------
print(f"H1 (Rock vs Pop): t = {t1:.2f}, p = {p1:.3f}")
print(f"H2 (Корреляция): r = {r_coeff:.2f}, p = {p2:.3f}")
print(f"H3 (Premium vs Free): t = {t3:.2f}, p = {p3:.3f}")

conclusions = [
    "H1: " + ("отвергаем H0: Средние оценки Rock и Pop релизов отличаюстя" if p1<0.05 else "подтверждаем H0: Средние оценки Rock и Pop релизов отличаюстя"),
    "H2: " + ("СУЩЕСТВУЕТ линейная корреляция между числом треков в релизе и его средним рейтингом" if p2<0.05 else "НЕ СУЩЕСТВУЕТ линейной корреляции между числом треков в релизе и его средним рейтингом"),
    "H3: " + ("Премиум пользователи ставят в среднем другие оценки" if p3<0.05 else "Премиум пользователи ставят в среднем те же оценки"),
]
print("\n".join(conclusions))

# Закрываем соединение
cursor.close()
conn.close()
