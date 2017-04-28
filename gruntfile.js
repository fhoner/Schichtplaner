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
                files: [
                    {
                        dest: 'dist/js/dependencies.js',
                        src: [
                            'node_modules/jquery/dist/jquery.min.js',
                            'node_modules/bootstrap/dist/js/bootstrap.min.js',
                            'node_modules/editable-table/mindmup-editabletable.js',
                            'node_modules/izitoast/dist/js/iziToast.min.js',
                            'node_modules/bootbox/bootbox.min.js',
                            'js/notify.js'
                        ],
                        nonull: true
                    },
                    {
                        dest: 'dist/js/schichtplaner.js',
                        src: [
                            'dist/js/dependencies.js',
                            'node_modules/sortablejs/Sortable.min.js',
                            'node_modules/mustache/mustache.min.js',
                            'node_modules/easy-autocomplete/dist/jquery.easy-autocomplete.min.js',
                            'js/user.main.js'
                        ],
                        nonull: true
                    },
                    {
                        dest: 'dist/js/schichtplaner.admin.js',
                        src: [
                            'dist/js/dependencies.js',
                            'node_modules/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js',
                            'node_modules/bootstrap-switch/dist/js/bootstrap-switch.min.js',
                            'node_modules/bootstrap-formhelpers/dist/js/bootstrap-formhelpers.min.js',
                            'js/admin**.js',
                        ],
                        nonull: true
                    },
                ]
            }
        },

        cssmin: {
            options: {
                keepSpecialComments: 0
            },
            target: {
                files: [
                    {
                        dest: 'dist/css/core.css',
                        src: [
                            'node_modules/bootstrap/dist/css/bootstrap.min.css',
                            'node_modules/font-awesome/css/font-awesome.min.css',
                            'node_modules/izitoast/dist/css/iziToast.min.css',
                        ],
                        nonull: true
                    },
                    {
                        dest: 'dist/css/schichtplaner.css',
                        src: [
                            'dist/css/core.css',
                            'node_modules/magic-input/dist/magic-input.min.css',
                            'node_modules/easy-autocomplete/dist/easy-autocomplete.min.css',
                            'template/**.css',
                        ]
                    },
                    {
                        dest: 'dist/css/schichtplaner.admin.css',
                        src: [
                            'dist/css/core.css',
                            'node_modules/jquery-ui-dist/jquery-ui.min.css',
                            'node_modules/bootstrap-datepicker/dist/css/bootstrap-datepicker3.standalone.min.css',
                            'node_modules/bootstrap-formhelpers/dist/css/bootstrap-formhelpers.min.css',
                            'node_modules/bootstrap-switch/dist/css/bootstrap3/bootstrap-switch.min.css',
                            'template/admin/**.css',
                        ]
                    },
                ]
            }
        },

        clean: [
            'dist/js/dependencies.js',
            'dist/css/core.css'
        ]
    });

    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-clean');
    
    grunt.registerTask('default', ['uglify', 'cssmin', 'copy', 'clean']);
    grunt.registerTask('css', ['cssmin', 'copy', 'clean']);

};