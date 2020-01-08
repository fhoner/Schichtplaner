<?php

namespace Schichtplaner\Authentication;

use GuzzleHttp\Client;
use Psr\Http\Message\ResponseInterface;
use Schichtplaner\ConfigReader;

class JiraRestAuthProvider implements AuthProvider {

    private static $jiraRestEndpoint = '/rest/api/2/user?username=felix.honer&expand=groups,roles';

    public function authorize($username, $password): bool {
        try {
            $jiraResponse = $this->getJiraResponse($username, $password);
            return $this->isMemberOfGroup($jiraResponse);
        } catch (\Exception $ex) {
            if ($ex->getCode() === 401) {
                return false;
            }
            throw $ex; // other than 401 is unexpected
        }
    }

    private function getJiraResponse(string $username, string $password): ResponseInterface {
        $client = new Client();
        $url = ConfigReader::getConfigOption('auth/parameters/url') . self::$jiraRestEndpoint;
        return $client->request('GET', $url, [
            'auth' => [$username, $password]
        ]);
    }

    private function isMemberOfGroup(ResponseInterface $jiraResponse): bool {
        $groupName = ConfigReader::getConfigOption('auth/parameters/memberOf');
        $obj = json_decode($jiraResponse->getBody(), true);
        $groups = $obj['groups']['items'];

        if (!isset($groups) || !is_array($groups)) {
            return false;
        }

        foreach ($groups as $group) {
            $name = $group['name'];
            if (strcasecmp($name, $groupName) == 0) {
                return true;
            }
        }

        return false;
    }

}
