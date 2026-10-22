"""Ympäristökohtaiset muuttujat. Käyttö robot-tiedostossa:
    Variables    ${CURDIR}/../resources/shared/environments.py    ${EXEC_ENV}

Huom: TEST osoittaa yle.fi tuotantoon tässä demossa.
"""

ENVIRONMENTS = {
    "TEST": {
        "WEB_BASE_URL": "https://yle.fi",
        "API_BASE_URL": "https://yle.fi",
        "API_TIMEOUT": 15,          # sekuntia / pyyntö
    },
}


def get_variables(exec_env="TEST"):
    return ENVIRONMENTS[exec_env.upper()]
