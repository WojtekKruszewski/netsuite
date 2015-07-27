module NetSuite
  module Records
    # Beaware of possible gotcha when closing sales order. You need to set the
    # SalesOrder#custom_form to "Basic Sales Order Form" otherwise you might get
    # errors when trying to close it
    class PurchaseOrderItem
      include Support::Fields
      include Support::RecordRefs
      include Support::Records
      include Namespaces::TranPurch

      fields :amount, :description, :expected_receipt_date, :gross_amt, :is_billable, :is_closed, :line, :match_bill_to_receipt,
        :quantity, :quantity_available, :quantity_billed, :quantity_on_hand, :quantity_received, :rate, :serial_numbers, :tax1_amt,
        :tax_rate1, :tax_rate2, :vendor_name

      field :custom_field_list, CustomFieldList

      record_refs :created_from, :customer, :department, :item, :klass, :landed_cost_category, :location, :purchase_contract,
        :tax_code, :units

      def initialize(attributes_or_record = {})
        case attributes_or_record
        when Hash
          initialize_from_attributes_hash(attributes_or_record)
        when self.class
          initialize_from_record(attributes_or_record)
        end
      end

      def initialize_from_record(record)
        self.attributes = record.send(:attributes)
      end

      def to_record
        rec = super
        if rec["#{record_namespace}:customFieldList"]
          rec["#{record_namespace}:customFieldList!"] = rec.delete("#{record_namespace}:customFieldList")
        end
        rec
      end
    end
  end
end
