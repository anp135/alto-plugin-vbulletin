<?php

Class Vbulletin {
    public function vb_hash($sPassword) {
        //135. Need for generate new hash password.
        //$sSalt = E::ModuleCache()->Get(md5($sPassword) . '_salt');
        //return md5(md5($sPassword) . $sSalt);
    }

    public function vb_check_hash($sPassword, $sHash){
        $sSalt = $_SESSION['salt'];
        unset($_SESSION['salt']);
        return ($sHash === md5(md5($sPassword) . $sSalt)) ? true : false;
    }
    public function fetch_user_salt($length = SALT_LENGTH)
    {
        $salt = '';

        for ($i = 0; $i < $length; $i++)
        {
            $salt .= chr(rand(33, 126));
        }

        return $salt;
    }
    public function fetch_substr_ip($ip, $length = null)
    {
        if ($length === null OR $length > 3)
        {
            $length = Config::Get('plugin.vbbulletin.ipcheck');
        }
        return implode('.', array_slice(explode('.', $ip), 0, 4 - $length));
    }
    public function fetch_idhash() {
        return md5($_SERVER['HTTP_USER_AGENT'] . $this->fetch_substr_ip(F::GetUserIp()));
    }
}
?>