class Source < ActiveRecord::Base
  has_one :note, dependent: :destroy
  
  validates_uniqueness_of :name
  validates_presence_of :name
  
  def files
    @files = []

    if File.exists? preview
      @files << { :type => :preview, :source_name => self.name, :filename => preview }
    end

    if File.exists? saturation_png
      @files << { :type => :saturation, :source_name => self.name, :filename => saturation_png }
    end

    @files
  end
  
  def preview_exists?
    File.exists? self.preview
  end

  def preview
    File.join(path, "#{name}_gm_rgb.png")
  end

  def saturation_png
    File.join(path, "#{name}_gm.smo.png")
  end

  def saturation_yml
    File.join(path, "#{name}_gm.smo.yml")
  end

  def saturation_percent
    total = 0; sat = 0

    saturation_metadata.each do |item|
      total += item['valid_data_pixels'].to_i
      sat += item['saturated_data_pixels'].to_i
    end

    sat.to_f / total.to_f * 100
  end

  def path
    Rails.root.join('previews/spot_preview_test').to_s
  end

  def metadata
    @metadata ||= YAML.load_file(preview + ".yml") if File.exists? preview + ".yml"
    @metadata
  end

  def saturation_metadata
    @saturation ||= YAML.load_file(saturation_yml) if File.exists? saturation_yml
    @saturation ||= []
    @saturation
  end
  
  def geom
    return [] if metadata.nil?

    geomll = metadata['geometry_ll']

    # Actual Bounding box
#    ul = [geomll['upper_left_lon'],geomll['upper_left_lat']]
#    ur = [geomll['upper_right_lon'], geomll['upper_right_lat']]
#    ll = [geomll['lower_left_lon'], geomll['lower_left_lat']]
#    lr = [geomll['lower_right_lon'], geomll['lower_right_lat']]
#    p = Polygon.from_coordinates([[ul, ur, lr, ll, ul]])
#    p.srid = 4326

    # Bounding box for Polyline encoder
    ul = [geomll['upper_left_lat'],geomll['upper_left_lon']]
    ur = [geomll['upper_right_lat'], geomll['upper_right_lon']]
    ll = [geomll['lower_left_lat'],geomll['lower_left_lon']]
    lr = [geomll['lower_right_lat'],geomll['lower_right_lon']]

    [ul,ur,lr,ll,ul]
  end
end
