CREATE TRIGGER `vbulletin-3.8.7`.``vb_session_delete` BEFORE DELETE ON `vb_session`
 FOR EACH ROW run: BEGIN
 DECLARE alto_user_id integer DEFAULT NULL;
 DECLARE group_id integer DEFAULT NULL;
 IF OLD.userid = 1 OR OLD.useragent LIKE 'alto%' THEN
  LEAVE run;
 END IF;

 SELECT alto.user_id, forum.usergroupid INTO alto_user_id, group_id FROM `vbulletin-3.8.7`.vb_user forum
  LEFT JOIN `alto_1.1.19`.prefix_user alto ON alto.user_login = forum.username
  WHERE forum.userid = OLD.userid;

 IF alto_user_id IS NULL || group_id = 1 || group_id = 3 || group_id = 4 || group_id = 8 THEN LEAVE run; END IF;

 UPDATE `alto_1.1.19`.prefix_session SET
     session_exit = now(),
     session_agent_hash = 'forum'
  WHERE
      session_key = OLD.sessionhash AND
      user_id = alto_user_id AND
      session_exit IS NULL;
END