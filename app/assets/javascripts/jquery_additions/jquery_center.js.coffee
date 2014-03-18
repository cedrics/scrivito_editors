jQuery.fn.center = ->
  if @length == 1
    @css
      marginLeft: -this.innerWidth() / 2
      marginTop: -this.innerHeight() / 2
      left: '50%'
