# frozen_string_literal: true
#
module Keywords
  COUNTRY_NAMES = {
    'AU' => 'Australia',
    'UK' => 'United Kingdom'
  }.freeze

  LOCATIONS = [
    'Amsterdam',
    ['Ann Arbor', state: 'MI'],
    ['Arlington', state: 'VA'],
    ['Atlanta', state: 'GA'],
    ['Auckland'],
    ['Austin', state: 'TX'],
    ['Bangalore', aliases: ['Bengaluru']],
    'Bangkok',
    'Barcelona',
    'Beijing',
    ['Bellevue', state: 'WA'],
    ['Berkeley', state: 'CA'],
    'Berlin',
    ['Bogota', aliases: ['Bogotá']],
    ['Boston', state: 'MA'],
    ['Boulder', state: 'CO'],
    'Braga',
    'Bratislava',
    'Brisbane',
    ['Brooklyn', state: 'NY'],
    'Brussels',
    'Budapest',
    ['Burlingame', state: 'CA'],
    ['Cambridge', state: 'MA', strict: true],
    ['Cambridge', country: 'UK', strict: true, aliases: ['Cambridgeshire']],
    'Cape Town',
    ['Charlotte', state: 'NC'],
    'Chennai',
    ['Chicago', state: 'IL'],
    ['Cincinnati', state: 'OH'],
    ['Cologne', alises: ['Köln']],
    ['Cupertino', state: 'CA'],
    ['Dallas', state: 'TX'],
    ['Washington', state: 'DC', finder: ->(text) { text.index(/\bDC\b|\bD\.C\.\b/) }],
    ['Denver', state: 'CO'],
    ['Detroit', state: 'MI'],
    ['Draper', state: 'UT'],
    'Dubai',
    'Dublin',
    ['Durham', state: 'NC'],
    'Edinburgh',
    'Eindhoven',
    ['Emeryville', state: 'CA'],
    'Geneve',
    'Guadalajara',
    'Hangzhou',
    'Helsinki',
    'Hong Kong',
    ['Houston', state: 'TX'],
    'Hyderabad',
    ['Irvine', state: 'CA'],
    ['Irving', state: 'TX'],
    'Istanbul',
    'Lausanne',
    ['Los Angeles', aliases: ['Santa Monica', 'Hollywood']],
    ['Kansas City', state: 'KS'],
    ['Knoxville', state: 'TN'],
    ['Lincoln', state: 'NE'],
    'Lisbon',
    'London',
    ['Los Gatos', state: 'CA'],
    'Madrid',
    'Manila',
    ['Melbourne', country: 'AU'],
    ['Melbourne', state: 'FL'],
    ['Menlo Park', state: 'CA'],
    'Mexico City',
    'Milan',
    ['Mountain View', state: 'CA'],
    'Montreal',
    'Mumbai',
    'Munich',
    'New Delhi',
    ['New York', state: 'NY', aliases: ['NYC', 'Manhattan']],
    ['Newton', state: 'MA', strict: true],
    ['Oakland', state: 'CA'],
    ['Oklahoma City', state: 'OK'],
    'Oslo',
    'Oxford',
    ['Palo Alto', state: 'CA'],
    'Paris',
    'Perth',
    ['Phoenix', state: 'AZ', strict: true],
    ['Philadelphia', state: 'PA'],
    ['Pittsburgh', state: 'PA'],
    ['Portland', state: 'OR'],
    'Prague',
    ['Princeton', state: 'NJ'],
    'Pune',
    ['Raleigh', state: 'NC'],
    ['Redwood City', state: 'CA'],
    ['Remote', finder: ->(text) { text.index(/(?<!No.)Remote/i) }],
    'Rotterdam',
    ['Salt Lake City', state: 'UT'],
    ['San Diego', state: 'CA'],
    ['San Francisco', state: 'CA', finder: ->(text) { text.index(/\bSan Francisco\b|\bSF\b|\bBay Area\b/i) }],
    ['San Jose', state: 'CA'],
    ['San Mateo', state: 'CA'],
    ['San Ramon', state: 'CA'],
    ['Santa Cruz', state: 'CA'],
    ['Sao Paulo', aliases: ['São Paulo']],
    ['Seattle', state: 'WA'],
    'Seoul',
    'Shanghai',
    'Shenzhen',
    'Singapore',
    ['Sterling', state: 'VA'],
    'Stockholm',
    ['Sunnyvale', state: 'CA'],
    'Sydney',
    ['Tampa', state: 'FL'],
    'Tokyo',
    'Toronto',
    'Trondheim',
    ['Tucson', state: 'AZ'],
    'Vancouver',
    'Vienna',
    ['Waltham', state: 'MA'],
    'Warsaw',
    'Wellington',
    'Zurich'
  ].freeze

  def self.process_locations
    locations = []

    LOCATIONS.each do |name, **extra|
      full_name = [name, extra[:state], COUNTRY_NAMES[extra[:country]]].compact.join(', ')
      options = {}
      if extra[:finder]
        options[:finder] = extra[:finder]
      elsif extra[:strict]
        options[:aliases] = extra[:aliases] || []
        options[:aliases] << "#{name},? #{extra[:state]}" if extra[:state]
        options[:aliases] << "#{name},? #{extra[:country]}" if extra[:country]
        options[:aliases] << "#{name},? #{COUNTRY_NAMES[extra[:country]]}" if extra[:country]
      elsif full_name != name
        options[:aliases] = extra[:aliases] || []
        options[:aliases] << name
      end
      locations << [full_name, options]
    end

    locations
  end
end

KeywordFinder.append(:locations, Keywords.process_locations)
