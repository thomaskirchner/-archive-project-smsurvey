from tornado import process
from tornado.ioloop import IOLoop

from smsurvey.core.model.query.dao import DAO
from smsurvey.core.model.model import Model
from smsurvey.schedule import schedule_master
from smsurvey.interface import interfaces_master
from smsurvey import config
from smsurvey.core.services.instance_service import InstanceService


if __name__ == "__main__":
    Model.from_database(config.DAO)
    process_id = process.fork_processes(config.response_interface_processes + 2, max_restarts=0)

    if process_id < config.response_interface_processes:
        port = config.survey_response_interface_port_begin + process_id
        interfaces_master.start_interface(port)

    elif process_id < config.response_interface_processes + 1:
        schedule_master.start_schedule()
    else:
        InstanceService.run_loop()

    try:
        IOLoop.current().start()
    except:
        IOLoop.current().stop()
