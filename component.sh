#!/bin/bash

mkdir "lib/app/modules/$1/$2_component"

slidy generate w modules/$1/$2_component/$2_component

slidy generate r modules/$1/$2_component/$2_component

slidy generate mbx modules/$1/$2_component/$2_component

slidy generate mbx modules/$1/$2_component/form_validation/$2_form_validation

slidy generate mbx modules/$1/$2_component/form_validation/$2_form

slidy generate page modules/$1/$2_component/$2_component

mkdir "lib/app/modules/$1/$2_component/$2_component_data_source"

touch "lib/app/modules/$1/$2_component/$2_component_data_source/$2_component.graphql"

touch "lib/app/modules/$1/$2_component/$2_component_data_source/$2_component_data_source.dart"

echo "$2_component created successfully"