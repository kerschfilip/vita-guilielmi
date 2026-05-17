
xquery version "3.1";

module namespace pm-config="http://www.tei-c.org/tei-simple/pm-config";

import module namespace pm-vangogh-web="http://www.tei-c.org/pm/models/vangogh/web/module" at "../transform/vangogh-web-module.xql";
import module namespace pm-vangogh-print="http://www.tei-c.org/pm/models/vangogh/print/module" at "../transform/vangogh-print-module.xql";
import module namespace pm-vangogh-epub="http://www.tei-c.org/pm/models/vangogh/epub/module" at "../transform/vangogh-epub-module.xql";
import module namespace pm-osinski-web="http://www.tei-c.org/pm/models/osinski/web/module" at "../transform/osinski-web-module.xql";
import module namespace pm-osinski-print="http://www.tei-c.org/pm/models/osinski/print/module" at "../transform/osinski-print-module.xql";
import module namespace pm-osinski-epub="http://www.tei-c.org/pm/models/osinski/epub/module" at "../transform/osinski-epub-module.xql";
import module namespace pm-teipublisher-web="http://www.tei-c.org/pm/models/teipublisher/web/module" at "../transform/teipublisher-web-module.xql";
import module namespace pm-teipublisher-print="http://www.tei-c.org/pm/models/teipublisher/print/module" at "../transform/teipublisher-print-module.xql";
import module namespace pm-teipublisher-epub="http://www.tei-c.org/pm/models/teipublisher/epub/module" at "../transform/teipublisher-epub-module.xql";
import module namespace pm-dta-web="http://www.tei-c.org/pm/models/dta/web/module" at "../transform/dta-web-module.xql";
import module namespace pm-dta-print="http://www.tei-c.org/pm/models/dta/print/module" at "../transform/dta-print-module.xql";
import module namespace pm-dta-epub="http://www.tei-c.org/pm/models/dta/epub/module" at "../transform/dta-epub-module.xql";
import module namespace pm-shakespeare-web="http://www.tei-c.org/pm/models/shakespeare/web/module" at "../transform/shakespeare-web-module.xql";
import module namespace pm-shakespeare-print="http://www.tei-c.org/pm/models/shakespeare/print/module" at "../transform/shakespeare-print-module.xql";
import module namespace pm-shakespeare-epub="http://www.tei-c.org/pm/models/shakespeare/epub/module" at "../transform/shakespeare-epub-module.xql";

declare variable $pm-config:web-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-web:transform($xml, $parameters)
case "osinski.odd" return pm-osinski-web:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-web:transform($xml, $parameters)
case "dta.odd" return pm-dta-web:transform($xml, $parameters)
case "shakespeare.odd" return pm-shakespeare-web:transform($xml, $parameters)
    default return pm-teipublisher-web:transform($xml, $parameters)
            

};
            


declare variable $pm-config:print-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-print:transform($xml, $parameters)
case "osinski.odd" return pm-osinski-print:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-print:transform($xml, $parameters)
case "dta.odd" return pm-dta-print:transform($xml, $parameters)
case "shakespeare.odd" return pm-shakespeare-print:transform($xml, $parameters)
    default return pm-teipublisher-print:transform($xml, $parameters)
            

};
            


declare variable $pm-config:epub-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    switch ($odd)
    case "vangogh.odd" return pm-vangogh-epub:transform($xml, $parameters)
case "osinski.odd" return pm-osinski-epub:transform($xml, $parameters)
case "teipublisher.odd" return pm-teipublisher-epub:transform($xml, $parameters)
case "dta.odd" return pm-dta-epub:transform($xml, $parameters)
case "shakespeare.odd" return pm-shakespeare-epub:transform($xml, $parameters)
    default return pm-teipublisher-epub:transform($xml, $parameters)
            

};
            


declare variable $pm-config:tei-transform := function($xml as node()*, $parameters as map(*)?, $odd as xs:string?) {
    error(QName("http://www.tei-c.org/tei-simple/pm-config", "error"), "No default ODD found for output mode tei")

};
            
    