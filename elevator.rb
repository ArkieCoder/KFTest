
class ElevatorSimulation
    def initialize(elevator_count, floor_count) 
        @elevator_count = elevator_count
        @floor_count = floor_count
        @elevators = Array.new
        elevator_count.times do
            @elevators << Elevator.new(@floor_count)
        end
    end

    def request(req_floor)

    end
end

class Elevator
    def initialize(floor_count) 
        @floor_count = floor_count
        @trip_count = 0
        @floors_passed = 0
        @current_floor = 1
        @occupied = false
        @doors_open = false
    end

    def request(req_floor)
        print "received request from floor #{req_floor}"
        make_trip(req_floor)
    end

    def make_trip(to_floor)
        close
        move_elevator(to_floor - @current_floor)
        open
        print "made a trip from #@current_floor to #{to_floor}"
        @trip_count++
    end

    def move_elevator(index) 
        print "moving elevator #{index} floors"
        @current_floor += index
        @floors_passed += index.abs
        print "this elevator has passed #@floors_passed floors"
    end

    def open
        print "elevator door is open"
        @doors_open = true
    end

    def close
        print "elevator door is closed"
        @doors_open = false
    end
end