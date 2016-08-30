app.controller 'PhonesCtrl', [
  '$scope'
  '$rootScope'
  'Phone'
  '$state'
  ($scope, $rootScope, Model, $state) ->
    $('.loading').show()

    $scope.load_phones = ->
      $('.loading').show()
      Model.get { url: $scope.brand }, (res) ->
        $rootScope.phones = res
        $rootScope.phone = null

    $scope.show_phone = ->
      $('.loading').show()
      Model.get { id: 0, url: $scope.phone }, (res) ->
        $rootScope.phone = res
]
