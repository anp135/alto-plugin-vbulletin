<?php

class PluginVbulletin_ModuleSecurity extends PluginVbulletin_Inherit_ModuleSecurity {

    public function Init() {
        parent::Init();
        F::IncludeFile(Plugin::GetPath('vbulletin') . 'libs/vbulletin_functions.php');
    }

    //135. Need for change password via Alto.
    /* public function Salted($sData, $sType = null) {
        $vbulletin = new Vbulletin();
        return ($sType == 'pass') ? $vbulletin->vb_hash($sData) : parent::Salted($sData, $sType);
    } */
    public function CheckSalted($sSalted, $sData, $sType = null) {
        $vbulletin = new Vbulletin();
        return ($sType == 'pass') ? $vbulletin->vb_check_hash(($sData), $sSalted) : parent::CheckSalted($sSalted, $sData, $sType);
    }
}
?>