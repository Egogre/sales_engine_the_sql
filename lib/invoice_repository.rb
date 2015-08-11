require_relative 'general_repository'

class InvoiceRepository
  include GeneralRepository

  def table
    'invoices'
  end

end
