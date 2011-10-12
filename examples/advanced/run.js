var modul8 = require('./../../index.js');
var dir = __dirname;

homebrewMinifier = function(code){
  return code.replace(/\n/,'');
};

domLoader = function(code){
  // we set this because the default assumes jQuery exists or is arbitered
  return "(function(){"+code+"})();";
};

modul8('main.coffee')
  .before(modul8.testcutter)
  .after(homebrewMinifier)
  .libraries()
    .list(['monolith.js'])
    .path(dir+'/libraries/')
  .arbiters()
    .add('monolith')
  .domains()
    .add('app', dir+'/app_code/')
    .add('shared', dir+'/shared_code/')
  .analysis()
    .output(console.log)
    .prefix(true)
  .set('namespace', 'QQ')
  .set('domloader', domLoader)
  .compile('./output.js');
