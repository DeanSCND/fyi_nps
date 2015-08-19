class FluidsController < ApplicationController

  def index
    @run = params[:run_id]
    run = Run.where(:id => @run).first

    fluid = Fluid::Api.new('dean.skelton@fyidoctors.com', 'Fyidoctors2014?!')
    fluid.create_collector(537808, "COLLECTOR_" + run.name)

    count = Patient.where(:run_id => run.id).count()
    batches = (count.to_f/4999.to_f).ceil
    logger.debug("COUNT: " + count.to_s + "  :  " + batches.to_s)

    last = 0
    for i in 1..batches
      logger.debug("LOOP " + i.to_s)
      list_id = fluid.create_list(run.name + "_" + i.to_s)

      patients = Patient.select('DISTINCT patients.id as id, patients.name, email, clinics.practice_id as "practice_id", clinics.name as "practice_name", replace(to_char("visitDate", \'Month dd, YYYY\'), \'  \', \' \') as "visit_date", runs.name || \'_' + i.to_s + '\' as "RUN"').where(:run_id => run.id).where("patients.id > ?", last.to_s).joins(:clinic).joins(:run).limit(4999).order("id ASC")

      patients.each do |patient|
        run_name = run.name + "_" + i.to_s
        fluid.create_contact_in_list(patient, run_name, list_id)
      end
    end
  end

end