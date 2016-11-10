CREATE TRIGGER `prefix_session_update` BEFORE UPDATE ON `prefix_session` FOR EACH ROW
run: BEGIN
 DECLARE vb_user_id integer DEFAULT NULL;
 DECLARE vb_last_login integer DEFAULT 0;
 DECLARE vb_view_online numeric DEFAULT 1;
 DECLARE trigger_key varchar(15) DEFAULT 'alto';

 IF NEW.session_agent_hash LIKE 'forum%' THEN
  SET NEW.session_agent_hash = OLD.session_agent_hash;
  LEAVE run;
 END IF;

 SELECT forum.userid
  INTO vb_user_id
  FROM `alto_1.1.19`.prefix_user alto
  LEFT JOIN `vbulletin-3.8.7`.vb_user forum ON alto.user_login = forum.username
  WHERE alto.user_id = NEW.user_id;

 IF vb_user_id IS NULL THEN LEAVE run; END IF;

 IF NEW.session_exit IS NOT NULL THEN SET trigger_key = 'alto:exit'; END IF;

 UPDATE `vbulletin-3.8.7`.vb_session SET
      userid = vb_user_id,
      lastactivity = UNIX_TIMESTAMP(now()),
      useragent = 'alto',
      location = '/'
 WHERE sessionhash = NEW.session_key;

IF trigger_key = 'alto:exit' THEN
 DELETE FROM `vbulletin-3.8.7`.vb_session WHERE sessionhash = NEW.session_key;
END IF;
 UPDATE `vbulletin-3.8.7`.vb_user SET lastactivity = UNIX_TIMESTAMP(now()) WHERE userid = vb_user_id;
END;