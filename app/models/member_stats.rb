class MemberStats
  def initialize(project_id, member_id)
    @project_id = project_id
    @member_id = member_id
  end

  attr_reader :project_id, :member_id

  def render_status_summary
    Pandas::DataFrame.new(status_summary).to_html
  end

  def render_status_summary_chart
    models = PyCall.import_module('bokeh.models')
    plotting = PyCall.import_module('bokeh.plotting')
    embed = PyCall.import_module('bokeh.embed')

    data = data_frame.groupby('status')[['id']].count()
    source = models.ColumnDataSource.new(data: data)
    x_range = [0, data['id'].max + 50]
    plot = plotting.figure(plot_width: 600, plot_height: 300,
                                 y_range: data_frame['status'].unique.tolist,
                                 x_range: x_range,
                                 toolbar_location: nil, tools: "")
    plot.hbar(y: 'status', right: 'id', height: 0.5, source: source)
    labels = models.LabelSet.new(y: 'status', x: 'id', text: 'id',
                                       level: 'glyph', y_offset: -10.0, x_offset: 5.0,
                                       source: source, render_mode: 'canvas')
    plot.add_layout(labels)
    embed.components(plot)
  end

  def status_summary
    @status_summary ||= data_frame['status'].value_counts
  end

  def issue_list
    data_frame.to_html
  end

  def data_frame
    @data_frame ||= Pandas.read_sql_query(<<-SQL, Issue.connection)
select
  issues.id,
  lower(trackers.name) tracker,
  lower(issue_statuses.name) status,
  issues.subject
from issues
left join trackers on trackers.id = issues.tracker_id
left join issue_statuses on issue_statuses.id = issues.status_id
left join members on members.user_id = issues.assigned_to_id
where
  issues.project_id = #{@project_id.to_i}
  and members.id = #{@member_id.to_i}
order by id asc
;
    SQL
  end
end
