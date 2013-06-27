module.exports = function(grunt) {
    'use strict';

    grunt.initConfig({

        watch: {
            coffee: {
                tasks: ['coffee:compile'],
                files: [
                    'coffee/**/*.coffee',
                    'templates/**/*.html'
                ]
            },

            buildRunner: {
                tasks: ['jasmine:tests:build'],
                files: ['spec/**/*.js']
            },

            sass: {
                tasks: ['sass'],
                files: ['scss/**/*.scss']
            }
        },

        coffee: {
            compile: {
                options: {
                    bare: true,
                    sourceMap: true
                },
                expand: true,
                cwd: 'coffee/',
                src: '**/*.coffee',
                dest: 'build',
                rename: function(dest, src) {
                    return dest + '/' + src.replace('.coffee', '.js');
                },
            }
        },

        sass: {
            dist: {
                files: {
                    'css/style.css': 'scss/style.scss'
                },
                options: {
                    //style: 'compressed',
                    quiet: true,
                    unixNewlines: true,
                    debugInfo: true
                }
            }
        },

        copy: {
            main: {
                files: [
                    {expand: true, cwd:'js/', src: ['**'], dest:'build'}
                ]
            }
        },
        symlink: {
            templates: {
                relativeSrc: '../templates',
                dest: 'build/templates',
                options: {type:'dir'}
            },
            extensions: {
                relativeSrc: '../extensions',
                dest: 'build/ext',
                options: {type:'dir'}
            },
        },
        requirejs: {
            distSrc: {
                options: {
                    baseUrl: '.',
                    appDir: 'build',
                    dir: 'dist/src',

                    optimize: 'none',
                    optimizeCss: 'none',
                    removeCombined: true,
                    preserveLicenseComments: false,
                    config: {
                        tpl: {
                            variable: 'data'
                        }
                    },
                    modules: [{
                        name: 'cilantro'
                    }, {
                        name: 'cilantro.ui'
                    }]
                }
            },

            distMin: {
                options: {
                    baseUrl: '.',
                    appDir: 'build',
                    dir: 'dist/min',

                    optimize: 'uglify2',
                    optimizeCss: 'none',
                    removeCombined: true,
                    preserveLicenseComments: false,

                    config: {
                        tpl: {
                            variable: 'data'
                        }
                    },

                    modules: [{
                        name: 'cilantro'
                    }, {
                        name: 'cilantro.ui'
                    }]
                }
            }
        },

        jasmine : {
            tests: {
                src : 'build/**/*.js',
                options : {
                    specs : 'spec/**/*Spec.js',
                    vendor: [
                        '/build/jquery.js',
                        '/spec/lib/jasmine-jquery.js',
                        '/spec/lib/jasmine.async.js',
                        '/spec/lib/mock-ajax.js'
                    ],
                    host: 'http://127.0.0.1:8125/',
                    template:'spec/runner.tmpl',
                    outfile: 'spec-runner.html',
                    keepRunner: true,
                    templateOptions: {
                        requireConfig: {
                            baseUrl: 'build/',
                            config: {
                                tpl: {
                                    variable: 'data'
                                }
                            }
                        }
                    }
                }
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-jasmine');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-requirejs');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-symlink');

    grunt.registerTask('default', ['jasmine', 'watch']);
    if (grunt.file.exists('extensions/')){
        grunt.registerTask('buildDist',['coffee','sass', 'copy', 'symlink', 'requirejs']);
    } else {
        grunt.registerTask('buildDist',['coffee','sass', 'copy', 'symlink:templates', 'requirejs']);
    }
};
