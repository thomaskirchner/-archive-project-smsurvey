DROP TABLE IF EXISTS state_version0;
DROP TABLE IF EXISTS instance;
DROP TABLE IF EXISTS schedule;
DROP TABLE IF EXISTS survey;
DROP TABLE IF EXISTS participant;
DROP TABLE IF EXISTS protocol;
DROP TABLE IF EXISTS plugin;
DROP TABLE IF EXISTS owner;

CREATE TABLE owner (
  name VARCHAR(25) NOT NULL UNIQUE,
  domain VARCHAR(25) NOT NULL,
  password VARCHAR(200) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  PRIMARY KEY(name, domain)
) CHARACTER SET utf8;

CREATE TABLE plugin (
  plugin_id INT NOT NULL UNIQUE AUTO_INCREMENT,
  owner_name VARCHAR(25) NOT NULL,
  owner_domain VARCHAR(25) NOT NULL,
  secret_token VARCHAR(200) NOT NULL,
  salt VARCHAR(100) NOT NULL,
  permissions INTEGER NOT NULL,
  poke_url VARCHAR(255) NOT NULL,
  PRIMARY KEY(plugin_id),
  FOREIGN KEY(owner_name, owner_domain) REFERENCES owner(name, domain) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE participant (
  participant_id VARCHAR(25) NOT NULL UNIQUE,
  plugin_id INT NOT NULL,
  plugin_scratch VARCHAR(100) NOT NULL,
  FOREIGN KEY (plugin_id) REFERENCES plugin (plugin_id) ON DELETE CASCADE,
  PRIMARY KEY(participant_id)
) CHARACTER SET utf8;

CREATE TABLE protocol (
  protocol_id INT NOT NULL UNIQUE AUTO_INCREMENT,
  first_question VARCHAR(100) NOT NULL,
  PRIMARY KEY(protocol_id)
) CHARACTER SET utf8;

CREATE TABLE survey (
  survey_id VARCHAR(25) NOT NULL UNIQUE,
  protocol_id INT NOT NULL,
  participant_id VARCHAR(25) NOT NULL,
  owner_name VARCHAR(25) NOT NULL,
  owner_domain VARCHAR(25) NOT NULL,
  PRIMARY KEY (participant_id),
  FOREIGN KEY (participant_id) REFERENCES participant (participant_id) ON DELETE CASCADE,
  FOREIGN KEY (owner_name, owner_domain) REFERENCES owner (name, domain) ON DELETE CASCADE,
  FOREIGN KEY (protocol_id) REFERENCES protocol (protocol_id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE schedule (
  task_id INT NOT NULL UNIQUE AUTO_INCREMENT,
  survey_id VARCHAR(25) NOT NULL,
  time_rule_id VARCHAR(100) NOT NULL,
  PRIMARY KEY (task_id),
  FOREIGN KEY (survey_id) REFERENCES survey (survey_id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE instance (
  instance_id INT NOT NULL UNIQUE AUTO_INCREMENT,
  survey_id VARCHAR(25) NOT NULL,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  timeout TIMESTAMP,
  PRIMARY KEY(instance_id),
  FOREIGN KEY(survey_id) REFERENCES survey(survey_id) ON DELETE CASCADE
) CHARACTER SET utf8;

CREATE TABLE state_version0 (
  state_id INT NOT NULL UNIQUE AUTO_INCREMENT,
  instance_id INT NOT NULL,
  question_id VARCHAR(100) NOT NULL,
  status INTEGER NOT NULL,
  priority TINYINT DEFAULT 0 NOT NULL,
  PRIMARY KEY(state_id),
  FOREIGN KEY(instance_id) REFERENCES instance(instance_id) ON DELETE CASCADE
) CHARACTER SET utf8;