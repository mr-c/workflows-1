cwlVersion: v1.0
class: CommandLineTool


requirements:
- $import: ./metadata/envvar-global.yml


hints:
- class: DockerRequirement
  dockerPull: biowardrobe2/bedops:v2.4.3


inputs:

  script:
    type: string?
    default: |
      cat "$0" > `basename $0`
    inputBinding:
      position: 1

  input_file:
    type: File
    inputBinding:
      position: 2

  param:
    type:
    - string?
    - string[]
    inputBinding:
      position: 3


outputs:

  filtered_file:
    type: File
    outputBinding:
      glob: $(inputs.input_file.basename)


baseCommand: [bash, '-c']


$namespaces:
  s: http://schema.org/

$schemas:
- http://schema.org/docs/schema_org_rdfa.html

s:name: "custom-bedops"
s:downloadUrl: https://raw.githubusercontent.com/Barski-lab/workflows/master/tools/custom-bedops.cwl
s:codeRepository: https://github.com/Barski-lab/workflows
s:license: http://www.apache.org/licenses/LICENSE-2.0

s:isPartOf:
  class: s:CreativeWork
  s:name: Common Workflow Language
  s:url: http://commonwl.org/

s:creator:
- class: s:Organization
  s:legalName: "Cincinnati Children's Hospital Medical Center"
  s:location:
  - class: s:PostalAddress
    s:addressCountry: "USA"
    s:addressLocality: "Cincinnati"
    s:addressRegion: "OH"
    s:postalCode: "45229"
    s:streetAddress: "3333 Burnet Ave"
    s:telephone: "+1(513)636-4200"
  s:logo: "https://www.cincinnatichildrens.org/-/media/cincinnati%20childrens/global%20shared/childrens-logo-new.png"
  s:department:
  - class: s:Organization
    s:legalName: "Allergy and Immunology"
    s:department:
    - class: s:Organization
      s:legalName: "Barski Research Lab"
      s:member:
      - class: s:Person
        s:name: Michael Kotliar
        s:email: mailto:michael.kotliar@cchmc.org
        s:sameAs:
        - id: http://orcid.org/0000-0002-6486-3898

doc: |
  Tool to run custom script set as `script` input with arguments from `param`. Based on bedops Dockerfile
  Default script runs sed command over the input file and exports results to the file with the same name as input's basename

  The temporary solution before the bedmap.cwl will be created

s:about: |
  Custom bash script runner