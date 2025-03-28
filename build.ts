import { type Build } from 'xbuild';

const build: Build = {
    common: {
        project: 'microtar',
        archs: ['x64'],
        variables: [],
        copy: {},
        defines: [],
        options: [],
        subdirectories: [],
        libraries: {
            'microtar': {
                sources: ['microtar/src/microtar.c']
            }
        },
        buildDir: 'build',
        buildOutDir: 'libs',
        buildFlags: []
    },
    platforms: {
        win32: {
            windows: {},
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {}
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;