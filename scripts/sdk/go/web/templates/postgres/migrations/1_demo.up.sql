CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    created_on TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_on TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_deleted BOOLEAN,
    deleted_on TIMESTAMPTZ
);
-- create user function
CREATE OR REPLACE FUNCTION create_user(first_name TEXT, last_name TEXT, email TEXT) RETURNS table(id INT) AS $BODY$
INSERT INTO users(first_name, last_name, email)
VALUES (
        create_user.first_name,
        create_user.last_name,
        create_user.email
    )
RETURNING user_id;
$BODY$ LANGUAGE sql;
-- update user function
CREATE OR REPLACE FUNCTION update_user(
        user_id INT,
        first_name TEXT,
        last_name TEXT,
        email TEXT
    ) RETURNS table(id INT) AS $BODY$
UPDATE public.users
SET first_name = update_user.first_name,
    last_name = update_user.last_name,
    email = update_user.email,
    updated_on = now()
WHERE user_id = update_user.user_id
RETURNING user_id;
$BODY$ LANGUAGE sql;
-- delete user function
CREATE OR REPLACE FUNCTION delete_user(user_id INT) RETURNS table(id INT) AS $BODY$
UPDATE public.users
SET deleted_on = now(),
    is_deleted = TRUE
WHERE user_id = delete_user.user_id
RETURNING user_id;
$BODY$ LANGUAGE sql;
-- dummy users
SELECT public.create_user(
        'Ainslie',
        'Haddow',
        'ahaddow0@redcross.org'
    );
SELECT public.create_user(
        'Sabina',
        'Walewicz',
        'swalewicz1@cdbaby.com'
    );
SELECT public.create_user(
        'Rana',
        'Gumley',
        'rgumley2@sphinn.com'
    );
SELECT public.create_user(
        'Ephrem',
        'Gillino',
        'egillino3@washington.edu'
    );
SELECT public.create_user(
        'Troy',
        'Raffon',
        'traffon4@typepad.com'
    );
SELECT public.create_user(
        'Micky',
        'Kilgour',
        'mkilgour5@oakley.com'
    );
SELECT public.create_user(
        'Arden',
        'Braunds',
        'abraunds6@paginegialle.it'
    );
SELECT public.create_user(
        'Tynan',
        'Jennery',
        'tjennery7@hao123.com'
    );
-- posts table
CREATE TABLE IF NOT EXISTS posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    content TEXT NOT NULL,
    author INTEGER NOT NULL,
    created_on TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_on TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    is_deleted BOOLEAN,
    deleted_on TIMESTAMPTZ,
    FOREIGN KEY(author) REFERENCES users(user_id)
);
-- post functions
-- dummy posts
INSERT INTO posts (title, content, author)
VALUES (
        'malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor',
        'turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris',
        1
    ),
    (
        'aenean fermentum donec ut mauris eget massa tempor convallis nulla neque libero',
        'mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue elementum',
        4
    ),
    (
        'eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum',
        'nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus et magnis dis',
        4
    );
