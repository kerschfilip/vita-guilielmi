
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-vita-guilielmi-web="http://www.tei-c.org/pm/models/vita-guilielmi/web/module" at "../transform/vita-guilielmi-web-module.xql";
import module namespace pm-vita-guilielmi-print="http://www.tei-c.org/pm/models/vita-guilielmi/print/module" at "../transform/vita-guilielmi-print-module.xql";
import module namespace pm-vita-guilielmi-epub="http://www.tei-c.org/pm/models/vita-guilielmi/epub/module" at "../transform/vita-guilielmi-epub-module.xql";
import module namespace pm-teipublisher-web="http://www.tei-c.org/pm/models/teipublisher/web/module" at "../transform/teipublisher-web-module.xql";
import module namespace pm-teipublisher-print="http://www.tei-c.org/pm/models/teipublisher/print/module" at "../transform/teipublisher-print-module.xql";
import module namespace pm-teipublisher-epub="http://www.tei-c.org/pm/models/teipublisher/epub/module" at "../transform/teipublisher-epub-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vita-guilielmi.odd" return pm-vita-guilielmi-web:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-web:transform($xml, $parameters)
    default return pm-vita-guilielmi-web:transform($xml, $parameters)
            

};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vita-guilielmi.odd" return pm-vita-guilielmi-print:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-print:transform($xml, $parameters)
    default return pm-vita-guilielmi-print:transform($xml, $parameters)
            

};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vita-guilielmi.odd" return pm-vita-guilielmi-epub:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-epub:transform($xml, $parameters)
    default return pm-vita-guilielmi-epub:transform($xml, $parameters)
            

};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")

};
            
    