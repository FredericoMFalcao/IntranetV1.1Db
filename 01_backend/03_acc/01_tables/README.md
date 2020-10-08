# Intro
This folder should contain .sql files that will be pre-parsed with a PHP engine.

Variables available at the PHP environment are:
- *version* - the current version installed on the server

# Sample Code
Sample code for a table called `users`

```sql
$version = ($_ENV['version']??1000);

<?php if ($version <= 1000) : ?>
CREATE TABLE Users (
  Username VARCHAR(255),
  Password VARCHAR(255)
);
<?php endif; ?>

<?php if ($version <= 1001) : ?>
ALTER TABLE Users ADD COLUMN Email VARCHAR(255) NOT NULL;
<?php endif; ?>

<?php if ($version <= 1002) : ?>
ALTER TABLE Users ADD COLUMN Age Int DEFAULT (0);
<?php endif; ?>
