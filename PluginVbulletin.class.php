<?php

if (!class_exists('Plugin')) {
	die('Hacking attempt!');
}

class PluginVbulletin extends Plugin {
        protected $aInherits = array(
            'module' => array(
                'ModuleSecurity',
                'ModuleUser',
                'ModuleSession',
            ),
            'entity' => array(
                'ModuleUser_EntityUser',
            ),
            'mapper' => array(
                'ModuleUser_MapperUser',
            ),
        );

        public function Activate() {
                return true;
        }

        public function Init() {
                return true;
        }

        public function Deactivate() {
                return true;
        }
}