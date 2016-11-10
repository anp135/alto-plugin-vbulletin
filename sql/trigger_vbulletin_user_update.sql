CREATE TRIGGER `vbulletin-3.8.7`.`vb_user_update` BEFORE UPDATE ON `vb_user`
 FOR EACH ROW run: BEGIN

 IF NEW.parentemail = 'alto' THEN
  SET NEW.parentemail = OLD.parentemail;
  LEAVE run;
 END IF;
 
 -- bugfix overlength username
 IF CHAR_LENGTH(OLD.username) > 30 || CHAR_LENGTH(NEW.username) > 30   THEN LEAVE run;
 END IF;

 -- need deactivate
 IF (NEW.usergroupid = 1 || NEW.usergroupid = 3 || NEW.usergroupid = 4 || NEW.usergroupid = 8) AND (OLD.usergroupid <> 1 AND OLD.usergroupid <> 3 AND OLD.usergroupid <> 4 AND OLD.usergroupid <> 8) THEN
  -- CALL replicate_vb_user(OLD.username, OLD.password,OLD.email, OLD.homepage, OLD.icq, OLD.skype, OLD.joindate, OLD.lastvisit, OLD.lastactivity, OLD.lastpost, OLD.timezoneoffset, OLD.showbirthday, OLD.birthday, OLD.ipaddress, OLD.salt);
 UPDATE `alto_1.1.19`.prefix_user SET user_activate = 0 WHERE user_login = OLD.username;
 END IF;

 -- no need anything
 IF NEW.usergroupid = 1 || NEW.usergroupid = 3 || NEW.usergroupid = 4 || NEW.usergroupid = 8 THEN LEAVE run; END IF;

  CALL replicate_vb_user(OLD.username, OLD.password,OLD.email, OLD.homepage, OLD.icq, OLD.skype, OLD.joindate, OLD.lastvisit, OLD.lastactivity, OLD.lastpost, OLD.timezoneoffset, OLD.showbirthday, OLD
.birthday, OLD.ipaddress, OLD.salt);

 -- need activate
 IF OLD.usergroupid = 1 || OLD.usergroupid = 3 || OLD.usergroupid = 4 || OLD.usergroupid = 8 THEN
 UPDATE `alto_1.1.19`.prefix_user SET user_activate = 1 WHERE user_login = OLD.username;
 END IF;

 -- change username
 IF NEW.username <> OLD.username THEN
  UPDATE `alto_1.1.19`.prefix_user SET user_login = NEW.username WHERE user_login = OLD.username;
 END IF;

 -- change password
 IF NEW.password <> OLD.password THEN
  UPDATE `alto_1.1.19`.prefix_user SET user_password = NEW.password WHERE user_login = NEW.username;
 END IF;

 -- change email
 IF NEW.email <> OLD.email THEN
  UPDATE `alto_1.1.19`.prefix_user SET user_mail = NEW.email WHERE user_mail = OLD.email;
 END IF;

END;