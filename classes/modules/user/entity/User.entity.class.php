<?php

class PluginVbulletin_ModuleUser_EntityUser extends PluginVbulletin_Inherit_ModuleUser_EntityUser {

    public function Init() {

        parent::Init();
    }

    public function getSalt() {

        return $this->getProp('user_salt');
    }
}

// EOF