<?php

namespace Schichtplaner\Authentication;

interface AuthProvider {
    public function authorize($username, $password);
}
