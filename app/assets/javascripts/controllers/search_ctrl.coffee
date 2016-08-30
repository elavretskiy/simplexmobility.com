app.controller 'SearchCtrl', [
  '$scope'
  '$rootScope'
  'Search'
  '$state'
  ($scope, $rootScope, Model, $state) ->
    $('.loading').show()

    $scope.search = ->
      $('.loading').show()
      Model.get { url: $scope.query }, (res) ->
        $rootScope.result = res
]
