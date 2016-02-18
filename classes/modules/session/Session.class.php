<?php

class PluginVbulletin_ModuleSession extends PluginVbulletin_Inherit_ModuleSession {

    public function Init() {
        parent::Init();
    }

    public function GetKey() {

        return parent::GetId();
    }
}
?>