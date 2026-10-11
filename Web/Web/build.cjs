// Vue CLI 3 can leave open handles on newer Node versions after webpack finishes.
// Exit only after its build promise resolves; rejected builds keep a failure code.
const Service = require('@vue/cli-service/lib/Service');
new Service(__dirname).run('build').then(() => process.exit(0)).catch(error => {
  console.error(error);
  process.exit(1);
});
