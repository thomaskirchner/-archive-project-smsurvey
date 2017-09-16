from smsurvey.core.model.model import Model
from smsurvey.core.model.query.where import Where

class TaskService:

    @staticmethod
    def create_task(task_name, survey_id, time_rule_id):
        tasks = Model.repository.tasks
        task = tasks.create()

        task.task_name = task_name
        task.survey_id = survey_id
        task.time_rule_id = time_rule_id

        return task.save()

    @staticmethod
    def get_all_tasks():
        tasks = Model.repository.tasks
        return tasks.select(force_list=True)

    @staticmethod
    def get_tasks_by_survey_id(survey_id):
        tasks = Model.repository.tasks
        return tasks.select(Where(tasks.survey_id, Where.E, survey_id))
