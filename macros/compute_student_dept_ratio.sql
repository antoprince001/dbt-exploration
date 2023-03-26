{% macro compute_student_dept_ratio(student_count,dept_count) %}
({{student_count}} * 1.0) / {{dept_count}}
{% endmacro %}