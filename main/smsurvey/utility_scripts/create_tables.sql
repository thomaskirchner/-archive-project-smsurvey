DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS state;
DROP TABLE IF EXISTS instance;
DROP TABLE IF EXISTS task;
DROP TABLE IF EXISTS survey;
DROP TABLE IF EXISTS participant;
DROP TABLE IF EXISTS enrollment;
DROP TABLE IF EXISTS protocol;
DROP TABLE IF EXISTS plugin;
DROP TABLE IF EXISTS owner;

CREATE TABLE owner (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  domain VARCHAR(25) NOT NULL,
  password VARCHAR(200) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  PRIMARY KEY(id),
  UNIQUE KEY (name, domain)
) CHARACTER SET utf8;

CREATE TABLE plugin (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  owner_id INT NOT NULL,
  secret_token VARCHAR(200) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  permissions VARCHAR(10) NOT NULL,
  url VARCHAR(255) NOT NULL,
  icon VARCHAR(25),
  PRIMARY KEY(id),
  FOREIGN KEY(owner_id) REFERENCES owner(id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE enrollment (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  name VARCHAR(25) NOT NULL,
  owner_id INT NOT NULL,
  open_date TIMESTAMP,
  close_date TIMESTAMP,
  expiry_date TIMESTAMP,
  PRIMARY KEY(id),
  FOREIGN KEY (owner_id) REFERENCES owner (id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE participant (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  plugin_id INT NOT NULL,
  enrollment_id INT NOT NULL,
  plugin_scratch VARCHAR(100) NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (plugin_id) REFERENCES plugin (id) ON DELETE CASCADE,
  FOREIGN KEY (enrollment_id) REFERENCES enrollment (id) ON DELETE CASCADE
) CHARACTER SET utf8;


CREATE TABLE protocol (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  owner_id INT NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY (owner_id) REFERENCES owner (id)
) CHARACTER SET utf8;

CREATE TABLE survey (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  protocol_id INT NOT NULL,
  enrollment_id INT NOT NULL,
  owner_id INT NOT NULL,
  enable_notes BOOL NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (enrollment_id) REFERENCES enrollment (id) ON DELETE CASCADE,
  FOREIGN KEY (owner_id) REFERENCES owner (id) ON DELETE CASCADE,
  FOREIGN KEY (protocol_id) REFERENCES protocol (id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE task (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  survey_id INT NOT NULL,
  time_rule_id VARCHAR(100) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (survey_id) REFERENCES survey (id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE instance (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  survey_id INT NOT NULL,
  participant_id INT NOT NULL,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  timeout TIMESTAMP,
  PRIMARY KEY(id),
  FOREIGN KEY(survey_id) REFERENCES survey(id) ON DELETE CASCADE,
  FOREIGN KEY (participant_id) REFERENCES participant(id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE state (
  id INT NOT NULL UNIQUE AUTO_INCREMENT,
  instance_id INT NOT NULL,
  question_number VARCHAR(100) NOT NULL,
  status INTEGER NOT NULL,
  priority TINYINT DEFAULT 0 NOT NULL,
  PRIMARY KEY(id),
  FOREIGN KEY(instance_id) REFERENCES instance(id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE session (
  id VARCHAR(200) NOT NULL UNIQUE,
  owner_id INT NOT NULL,
  expires TIMESTAMP NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (owner_id) REFERENCES owner (id) ON DELETE CASCADE
) CHARACTER SET utf8;