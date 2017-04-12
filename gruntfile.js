module.exports = function (grunt) {

    grunt.initConfig({

        copy: {
            main: {
                files: [
                    {
                        expand: true, flatten: true, src: ['node_modules/font-awesome/fonts/**'], dest: 'dist/fonts/', filter: 'isFile'
                    },
                    {
                        expand: true, flatten: true, src: ['node_modules/bootstrap/fonts/**'], dest: 'dist/fonts/', filter: 'isFile'
                    },
                ],
            },
        },

        uglify: {
            dist: {
                files: {
                    'dist/js/dependencies.js': [
                        'node_modules/jquery/dist/jquery.min.js',
                        'node_modules/bootstrap/dist/js/bootstrap.min.js',
                        'node_modules/bootbox/bootbox.min.js',
                        'node_modules/editable-table/mindmup-editabletable.js',
                        'node_modules/izitoast/dist/js/iziToast.min.js',
                        'js/notify.js'
                    ],
                    'dist/js/schichtplaner.js': [
                        'dist/js/dependencies.js',
                        'node_modules/sortablejs/Sortable.min.js',
                        'node_modules/mustache/mustache.min.js',
                        'js/user.main.js'
                    ],
                    'dist/js/schichtplaner.admin.js': [
                        'dist/js/dependencies.js',
                        'node_modules/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js',
                        'node_modules/bootstrap-switch/dist/js/bootstrap-switch.min.js',
                        'node_modules/bootstrap-formhelpers/dist/js/bootstrap-formhelpers.min.js',
                        'js/admin**.js',
                    ],
                },
                nonull: true
            }
        },

        cssmin: {
            options: {
                keepSpecialComments: 0
            },
            target: {
                files: {
                    'dist/css/core.css': [
                        'node_modules/bootstrap/dist/css/bootstrap.min.css',
                        'node_modules/font-awesome/css/font-awesome.min.css',
                        'node_modules/izitoast/dist/css/iziToast.min.css',
                    ],
                    'dist/css/schichtplaner.css': [
                        'dist/css/core.css',
                        'node_modules/magic-input/dist/magic-input.min.css',
                        'template/**.css',
                    ],
                    'dist/css/schichtplaner.admin.css': [
                        'dist/css/core.css',
                        'node_modules/jquery-ui-dist/jquery-ui.min.css',
                        'node_modules/bootstrap-datepicker/dist/css/bootstrap-datepicker3.standalone.min.css',
                        'node_modules/bootstrap-formhelpers/dist/css/bootstrap-formhelpers.min.css',
                        'node_modules/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css',
                        'template/admin/**.css',
                    ],
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-copy');
    
    grunt.registerTask('default', ['uglify', 'cssmin', 'copy']);
    grunt.registerTask('css', ['cssmin', 'copy']);

};