ALTER TABLE mods
    ADD COLUMN body varchar(65536) NOT NULL DEFAULT '';
ALTER TABLE mods
    ALTER COLUMN body_url DROP NOT NULL;
ALTER TABLE versions
    ADD COLUMN changelog varchar(65536) NOT NULL DEFAULT '';
