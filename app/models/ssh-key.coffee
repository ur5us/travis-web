`import Ember from 'ember'`
`import Model from 'travis/models/model'`

SshKey = Model.extend
  value:       DS.attr()
  description: DS.attr()
  fingerprint: DS.attr()
  isCustom: true

`export default SshKey`
