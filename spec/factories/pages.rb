FactoryGirl.define do
  factory :root_page, :class => Page do
    name    'root'
    title   "FIRST"
    text    "some text"
    page_id nil
  end

  factory :another_root_page, :class => Page do
    name 'another_root_page'
    title 'ANOTHER FIRST'
    text 'some text else'
    page_id nil
  end

  factory :sub1_page, :class => Page do
    name 'mother'
    title 'mothers Page'
    text 'some text'
    association :parent, factory: :root_page
  end

  factory :sub2_page, :class => Page do
    name 'father'
    title 'fathers page'
    text 'Im father '
    association :parent, factory: :root_page
  end

  factory :sub1sub1_page, :class => Page do
    name 'Son'
    title 'Sons page'
    text 'Im Petia'
    association :parent, factory: :sub1_page
  end
end
