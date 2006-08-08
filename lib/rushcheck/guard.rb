# = guard.rb
# This provides class Guard

class RushCheckGuard < StandardError; end

# class Guard is used for RushCheck internally and many user
# don't care about this class.
class Guard

  def guard_raise(c)
    begin
      yield
    rescue Exception => ex
      case ex
      when c
        raise RushCheckGuard
      else
        raise ex
      end
    end
  end

  def guard
    raise RushCheckGuard unless yield
  end

end
