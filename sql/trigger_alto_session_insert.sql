CREATE TRIGGER `prefix_session_insert` BEFORE INSERT ON `prefix_session` FOR EACH ROW
run: BEGIN
 DECLARE vb_user_id integer DEFAULT NULL;
 DECLARE vb_last_login integer DEFAULT 0;
 
 IF NEW.session_agent_hash LIKE 'forum%' THEN
  SET NEW.session_agent_hash = '';
  LEAVE run;
 END IF;

 SELECT forum.userid, forum.lastvisit 
  INTO vb_user_id, vb_last_login 
  FROM `alto_1.1.19`.prefix_user alto
  LEFT JOIN `vbulletin-3.8.7`.vb_user forum ON alto.user_login = forum.username
  WHERE alto.user_id = NEW.user_id;
 
 IF vb_user_id IS NULL THEN LEAVE run; END IF;
 IF vb_last_login IS NULL THEN SET vb_last_login = 0; END IF;
 
 INSERT INTO `vbulletin-3.8.7`.vb_session (
     sessionhash,
     userid,
     host,
     idhash,
     lastactivity,
     location,
     useragent,
     styleid,
     languageid,
     loggedin,
     inforum,
     inthread,
     incalendar,
     badlocation,
     bypass,
     profileupdate
     )
  VALUES (
      NEW.session_key,
      vb_user_id,
      NEW.session_ip_last,
      NEW.session_key,       UNIX_TIMESTAMP(now()),
      '/',
      'alto',
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0)
  ON DUPLICATE KEY UPDATE 
      userid = vb_user_id,
      lastactivity = UNIX_TIMESTAMP(now()),
      useragent = 'alto',
      location = '/';
 UPDATE `vbulletin-3.8.7`.vb_user SET lastactivity = UNIX_TIMESTAMP(now()) WHERE userid = vb_user_id;
END;
