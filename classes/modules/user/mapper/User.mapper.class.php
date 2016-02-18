<?php

class PluginVbulletin_ModuleUser_MapperUser extends PluginVbulletin_Inherit_ModuleUser_MapperUser {

    public function GetUsersByArrayId($aUsersId) {

        if (!is_array($aUsersId) || count($aUsersId) == 0) {
            return array();
        }

        $sql
            = "
            SELECT
                u.user_id AS ARRAY_KEY,
				u.*,
				ab.banline, ab.banunlim, ab.banactive, ab.bancomment,
				forum.salt AS user_salt
			FROM
				?_user as u
				LEFT JOIN ?_adminban AS ab ON u.user_id=ab.user_id AND ab.banactive=1
				LEFT JOIN " . Config::Get('plugin.vbulletin.db') . ".forum_user as forum ON forum.username = u.user_login
			WHERE
				u.user_id IN(?a)
			LIMIT ?d
			";
        $aUsers = array();
        if ($aRows = $this->oDb->select($sql, $aUsersId, count($aUsersId))) {
            $aUsers = E::GetEntityRows('User', $aRows, $aUsersId);
        }
        return $aUsers;
    }
}

// EOF