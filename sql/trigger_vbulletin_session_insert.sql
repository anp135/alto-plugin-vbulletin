CREATE TRIGGER `vbulletin-3.8.7`.`vb_session_insert` BEFORE INSERT ON `vb_session`
 FOR EACH ROW run: BEGIN
 DECLARE alto_user_id integer DEFAULT NULL;
 DECLARE group_id integer DEFAULT NULL;

 IF NEW.userid = 0 OR NEW.useragent = 'alto' THEN

  LEAVE run;
 END IF;

 SELECT alto.user_id, forum.usergroupid INTO alto_user_id, group_id FROM `vbulletin-3.8.7`.vb_user forum
  LEFT JOIN `alto_1.1.19`.prefix_user alto ON alto.user_login = forum.username
  WHERE forum.userid = NEW.userid;

 IF alto_user_id IS NULL || group_id = 1 || group_id = 3 || group_id = 4 || group_id = 8 THEN LEAVE run; END IF;

 INSERT INTO `alto_1.1.19`.prefix_session (
     session_key,
     user_id,
     session_agent_hash,
     session_ip_create,
     session_ip_last,
     session_date_create,
     session_date_last
     )
  VALUES (
      NEW.sessionhash,
      alto_user_id,
      'forum:',
      NEW.host,
      NEW.host,
      FROM_UNIXTIME(NEW.lastactivity),
      FROM_UNIXTIME(NEW.lastactivity)
      )
 ON DUPLICATE KEY UPDATE
      session_exit = NULL,
      session_agent_hash = 'forum',
      session_date_last = FROM_UNIXTIME(NEW.lastactivity);
 UPDATE `alto_1.1.19`.prefix_user SET
  user_last_session = NEW.sessionhash, user_activate_key = 'forum'
  WHERE user_id = alto_user_id;
END