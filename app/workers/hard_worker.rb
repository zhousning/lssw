class HardWorker
  include Sidekiq::Worker

  def perform
    @leafs = Leaf.where(["status = ? and unpick <= ?", Setting.leafs.enable, Setting.leafs.produce_max])
    @leafs.each do |leaf|
      if leaf.unpick < Setting.leafs.produce_max
        leaf.add_unpick(1)
      end
    end
  end
end
