CREATE TABLE drugs (
                       id               SERIAL PRIMARY KEY,
                       name             VARCHAR(200) NOT NULL,
                       active_substance VARCHAR(150) NOT NULL,
                       dosage_form      VARCHAR(50),
                       dosage           VARCHAR(50),
                       manufacturer     VARCHAR(200),
                       description      TEXT
);

CREATE TABLE pharmacies (
                            id      SERIAL PRIMARY KEY,
                            name    VARCHAR(150) NOT NULL,
                            address VARCHAR(250),
                            city    VARCHAR(100)
);

CREATE TABLE prices (
                        id          SERIAL PRIMARY KEY,
                        drug_id     INT NOT NULL REFERENCES drugs(id) ON DELETE CASCADE,
                        pharmacy_id INT NOT NULL REFERENCES pharmacies(id) ON DELETE CASCADE,
                        price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
                        updated_at  TIMESTAMP NOT NULL DEFAULT NOW(),
                        UNIQUE (drug_id, pharmacy_id)
);

CREATE INDEX idx_drugs_name ON drugs (name);
CREATE INDEX idx_drugs_substance ON drugs (active_substance);
CREATE INDEX idx_prices_drug ON prices (drug_id);