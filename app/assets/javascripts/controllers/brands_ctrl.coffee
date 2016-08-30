app.controller 'BrandsCtrl', [
  'Brand'
  'action'
  '$state'
  (Model, action, $state) ->
    ctrl = this
    $('.loading').show()

    action 'index', (params) ->
      ctrl.create = ->
        $('.loading').show()
        Model.create {}, (res) ->
          ctrl.brands = res

      ctrl.query = ->
        $('.loading').show()
        Model.get {}, (res) ->
          ctrl.brands = res
      ctrl.query()
]
