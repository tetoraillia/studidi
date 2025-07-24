# Simplified up method (re-paste this into your migration file)
class RenameCourseModulesToTopics < ActiveRecord::Migration[8.0]
  def up
    rename_table :course_modules, :topics
    rename_column :lessons, :course_module_id, :topic_id

    if index_exists?(:topics, :course_id, name: 'index_course_modules_on_course_id')
      rename_index :topics, 'index_course_modules_on_course_id', 'index_topics_on_course_id'
    end
    if index_exists?(:topics, :position, name: 'index_course_modules_on_position')
      rename_index :topics, 'index_course_modules_on_position', 'index_topics_on_position'
    end

    if index_exists?(:lessons, :topic_id, name: 'index_lessons_on_course_module_id')
      rename_index :lessons, 'index_lessons_on_course_module_id', 'index_lessons_on_topic_id'
    end
  end

  def down
    if index_exists?(:lessons, :course_module_id, name: 'index_lessons_on_topic_id')
      rename_index :lessons, 'index_lessons_on_topic_id', 'index_lessons_on_course_module_id'
    end

    rename_column :lessons, :topic_id, :course_module_id
    rename_table :topics, :course_modules

    if index_exists?(:course_modules, :course_id, name: 'index_topics_on_course_id')
      rename_index :course_modules, 'index_topics_on_course_id', 'index_course_modules_on_course_id'
    end
    if index_exists?(:course_modules, :position, name: 'index_topics_on_position')
      rename_index :course_modules, 'index_topics_on_position', 'index_course_modules_on_position'
    end
  end
end
