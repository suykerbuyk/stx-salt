# -*- coding: utf-8 -*-
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4

# /bin/env python3

# Import python libs
from __future__ import absolute_import, print_function, unicode_literals

import logging
# Import salt libs
# import salt.config
# import salt.minion
# import salt.utils.event
# import salt.utils.files
# import salt.utils.network
import salt.utils.path
import salt.utils.platform
import salt.exceptions
# import salt.utils.stringutils
# Import python libs
# from __future__ import absolute_import, print_function, unicode_literals
# import os
# import copy
# import logging
# Import salt libs
# import salt.utils.args
# import salt.utils.functools
# import salt.utils.json
# from salt.exceptions import CommandExecutionError, SaltRenderError
from salt.ext import six

log = logging.getLogger(__name__)
_s3_benchmark_bin = None


def is_installed():
    global _s3_benchmark_bin
    ret_msg = ''
    if _s3_benchmark_bin is not None:
        ret_msg = _s3_benchmark_bin
        log.debug(ret_msg)
        return(True, ret_msg)
    if salt.utils.platform.is_windows():
        ret_msg = 'Windows platform is not supported by this module'
        log.debug(ret_msg)
        return(False, ret_msg)
    _s3_benchmark_bin = salt.utils.path.which('s3-benchmark')
    if _s3_benchmark_bin is None:
        ret_msg = \
          'The s3-benchmark tool was not found on this system.\n  ' \
          'Recommended version can be found here:\n  ' \
          'https://github.com/minio/s3-benchmark/raw/master/s3-benchmark'
        return(False, ret_msg)
    else:
        return(True, _s3_benchmark_bin)


def mark(name,
         access_key=None,
         secret_key=None,
         loops=1,
         bucket=None,
         duration=10,
         json_out=False,
         tgt_url=None,
         threads=1,
         obj_size="1M",
         run_as="root",
         comment=''):
    '''
    Run an s3-benchmark test with parameters
    '''
    ret = {'name': name,
           'changes': {},
           'result': False,
           'comment': comment,
           'test': {}
           }

    if access_key is None:
        raise salt.exceptions.SaltInvocationError(
               'access_key must be set to the string'
               ' value required to acccess the target')
    if secret_key is None:
        raise salt.exceptions.SaltInvocationError(
               'secret_key must be set to the string'
               ' value required to acccess the target')
    if tgt_url is None:
        raise salt.exceptions.SaltInvocationError(
               'tgt_url must be set to the string'
               ' value required to acccess the target')
    have_s3_benchmark, msg = is_installed()
    if not have_s3_benchmark:
        raise salt.execptions.CommandNotFoundError(msg)
    if bucket is None:
        bucket = __opts__['id']
    # estimated_completion_time = duration + 10
    estimated_completion_time = 0
    if not (comment and comment.strip()):
        comment = name
    cmd_line = msg \
        + " -a {0} -s {1}  -d {2} -l {3} -j -t {4} -b {5} -z {6} -u {7}"\
        .format(access_key, secret_key, duration, loops,
                threads, bucket, obj_size, tgt_url)
    if __opts__['test']:
        ret['result'] = None
        ret['comment'] = 'Command "{0}" would have been executed' \
            .format(cmd_line)
        return ret

    try:
        cmd_all = __salt__['cmd.run_all'](
            cmd_line, timeout=estimated_completion_time,
            python_shell=False)
    except salt.exceptions.CommandExecutionError as err:
        ret['comment'] = six.text_type(err)
        return ret
    ret['changes'] = cmd_all
    ret['result'] = not bool(cmd_all['retcode'])
    ret['comment'] = '{0}'.format(cmd_line)
    test_results = cmd_all['stdout'].split()
    ret['test']['name'] = name
    ret['test']['node'] = __opts__['id']
    ret['test']['params'] = test_results[0]
    ret['test']['put'] = test_results[1]
    ret['test']['get'] = test_results[2]
    ret['test']['del'] = test_results[3]
    return ret


if __name__ == "__main__":
    print("Running self test")
    check, msg = is_installed()
    print(check, msg)
    if check is False:
        print("s3-benchmark not found on this system")
        exit(1)
    else:
        print("s3-benchmark is at ", _s3_benchmark_bin)
