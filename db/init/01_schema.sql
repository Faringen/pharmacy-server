CREATE TABLE active_substances (
                                   id   SERIAL PRIMARY KEY,
                                   name VARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE drugs (
                       id                  SERIAL PRIMARY KEY,
                       name                VARCHAR(200) NOT NULL,
                       manufacturer        VARCHAR(200),
                       form                VARCHAR(50),
                       dosage              VARCHAR(50),
                       description         TEXT,
                       active_substance_id INT NOT NULL REFERENCES active_substances(id)
);

CREATE TABLE pharmacies (
                            id      SERIAL PRIMARY KEY,
                            name    VARCHAR(150) NOT NULL,
                            address VARCHAR(250),
                            phone   VARCHAR(30)
);

CREATE TABLE prices (
                        id          SERIAL PRIMARY KEY,
                        drug_id     INT NOT NULL REFERENCES drugs(id) ON DELETE CASCADE,
                        pharmacy_id INT NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE,
                        price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
                        in_stock    BOOLEAN NOT NULL DEFAULT TRUE,
                        updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
                        UNIQUE (drug_id, pharmacy_id)
);

CREATE INDEX idx_drugs_name ON drugs (name);
CREATE INDEX idx_drugs_substance ON drugs (active_substance_id);
CREATE INDEX idx_prices_drug ON prices (drug_id);

-- Аналоги: препараты с тем же действующим веществом
CREATE VIEW drug_analogs AS
SELECT d1.id AS drug_id,
       d2.id AS analog_id,
       d2.name AS analog_name
FROM drugs d1
         JOIN drugs d2
              ON d1.active_substance_id = d2.active_substance_id
                  AND d1.id <> d2.id;