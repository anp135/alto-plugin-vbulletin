<?php

class PluginVbulletin_ModuleUser extends PluginVbulletin_Inherit_ModuleUser {
    public function Init() {
        parent::Init();
    }

    public function CheckPassword($oUser, $sCheckPassword) {

        $sUserPassword = $oUser->getPassword();
        $sUserSalt = $oUser->getSalt();
        $_SESSION['salt'] = $sUserSalt;
        Config::Set('security.salt_pass', $sUserSalt);
        if (E::ModuleSecurity()->CheckSalted($sUserPassword, $sCheckPassword, 'pass')
            || E::ModuleSecurity()->CheckSalted($sUserPassword, trim($sCheckPassword), 'pass')) {
            return true;
        }
        return false;
    }
}
?>