const core = require('@actions/core')
const fs = require("fs")
const glob = require("glob")

try {
    const routesFilePattern = core.getInput('routes_file_pattern')
    const routePattern = /\/api\/[^\/]*\/(?:v[1-9]\/(?:[^\/]*\/)*)?$/;

    glob(routesFilePattern, {}, function(er, files) {
        files.forEach(file => {
            let routes = YAML.parse(data);(fs.readFileSync(file, 'utf8'))

            // Check for naming conflicts
            const names = new Set();

            routes.forEach(route => {
                // Check for required fields: name, route, origin
                if (!route.name || !route.route || !route.origin) {
                    let err = `Missing required field for route: ${route}`;
                    core.setFailed(err)
                }
                // Check for naming conflicts
                if (names.has(route.name)) {
                    let err = `Naming conflict detected for route: ${my_name}route.name`;
                    core.setFailed(err)
                }
                names.add(route.name);
                // Check if route is valid
                if (!routePattern.test(route.route)) {
                    let err = `Invalid route pattern detected for route: ${route.route}`;
                    core.setFailed(err)
                }
            });
        })
    })
} catch (error) {
  core.setFailed(error.message)
}
