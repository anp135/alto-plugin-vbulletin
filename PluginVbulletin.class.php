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
            $sFileQuery = file_get_contents(__DIR__ . '/sql/trigger_alto_session_insert.sql');
            $bResult = E::ModuleDatabase()->GetConnect()->query($sFileQuery);
            if ($bResult === false) {
                $aErrors[] = $this->GetLastError();
                return false;
            }
            $sFileQuery = file_get_contents(__DIR__ . '/sql/trigger_alto_session_update.sql');
            $bResult = E::ModuleDatabase()->GetConnect()->query($sFileQuery);
            if ($bResult === false) {
                $aErrors[] = $this->GetLastError();
                return false;
            }
            $sFileQuery = file_get_contents(__DIR__ . '/sql/trigger_vbulletin_session_insert.sql');
            $bResult = E::ModuleDatabase()->GetConnect()->query($sFileQuery);
            if ($bResult === false) {
                $aErrors[] = $this->GetLastError();
                return false;
            }
            return true;
        }

        public function Init() {
                return true;
        }

        public function Deactivate() {
            $this->ExportSQL(__DIR__ . '/sql/deactivate.sql');
                return true;
        }
}